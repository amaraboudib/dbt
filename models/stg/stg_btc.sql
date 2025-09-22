{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'hash_key',
    file_format = 'parquet'
) }}

select * 
from {{source('BTC', 'BTC')}}

{% if is_incremental() %}
where block_timestamp > (select max(block_timestamp) from {{ this }})
{% endif %}