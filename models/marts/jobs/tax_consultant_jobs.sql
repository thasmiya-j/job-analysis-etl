select role_category, title, company, location, experience, salary, link, load_timestamp, batch_id, flag
from {{ ref('int_jobs') }}
where role_category = 'tax_consultant'