with current_jobs as (

    select *
    from {{ ref('history_jobs') }}
    where flag = 1

),

normalized as (

    select
        cj.*,
        case
            when lower(role_raw) = 'data-analyst'       then 'data_analyst'
            when lower(role_raw) = 'data-engineer'       then 'data_engineer'
            when lower(role_raw) = 'business-analyst'    then 'business_analyst'
            when lower(role_raw) = 'accountant'          then 'accountant'
            when lower(role_raw) = 'financial analyst'   then 'financial_analyst'
            when lower(role_raw) = 'tax consultant'      then 'tax_consultant'
            else 'other'
        end as role_category
    from current_jobs cj

)

select
    role_category,
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
    flag
from normalized