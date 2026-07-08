select
    trim("ROLE")                    as role_raw,
    try_cast(page as number)        as page,
    nullif(trim(title), '')         as title,
    nullif(trim(company), '')       as company,
    nullif(trim(location), '')      as location,
    nullif(trim(experience), '')    as experience,
    nullif(trim(salary), '')        as salary,
    link,
    load_timestamp,
    batch_id
from {{ source('staging', 'STG_ALL_JOBS') }}
where link is not null and link != ''