{% macro convert_to_us(column_name) %}

{{column_name}} * 
(

    select price from {{ref('btc_usd_max')}} 
    where to_date(replace(snapped_at, ' UTC', '')) = current_date()


)
{% endmacro %}