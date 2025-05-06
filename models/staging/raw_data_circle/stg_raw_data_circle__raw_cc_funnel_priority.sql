with 

source as (

    select * from {{ source('raw_data_circle', 'raw_cc_funnel_priority') }}

),

renamed as (

    select
        compny_name as company,
        priority

    from source

)

select * from renamed
