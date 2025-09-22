{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key = 'hash_key',
    file_format = 'parquet'
) }}

with flattened_outputs as ( 
select 
tx.hash_key, 
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address as output_address,
f.value:value::float as output_value

from {{ ref('stg_btc') }} tx, 
lateral flatten(input => outputs ) f

where f.VALUE:address is not NULL


{% if is_incremental() %}
and tx.block_timestamp > (select max(block_timestamp) from {{ this }})
{% endif %}

)

select * from flattened_outputs

