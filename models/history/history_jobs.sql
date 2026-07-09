{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        post_hook=[
            "UPDATE {{ this }} SET FLAG = 0",
            "UPDATE {{ this }} t
             SET FLAG = 1
             FROM (
                 SELECT
                     link,
                     load_timestamp,
                     batch_id,
                     ROW_NUMBER() OVER (
                         PARTITION BY link
                         ORDER BY load_timestamp DESC, batch_id DESC
                     ) AS rn
                 FROM {{ this }}
             ) ranked
             WHERE t.link = ranked.link
               AND t.load_timestamp = ranked.load_timestamp
               AND t.batch_id = ranked.batch_id
               AND ranked.rn = 1",
            "TRUNCATE TABLE NAUKRI_DB.STAGING.STG_ALL_JOBS"
        ]
    )
}}

select
    role_raw,
    page,
    title,
    company,
    location,
    experience,
    salary,
    link,
    load_timestamp,
    batch_id,
    cast(null as number) as flag
from {{ ref('stg_jobs') }}

{% if is_incremental() %}
where load_timestamp > (select coalesce(max(load_timestamp), '2026-07-01'::timestamp_ntz) from {{ this }})
{% endif %}