with 

source as (

    select * from {{ source('circle', 'funnel_priority') }}

),

renamed as (

    select
        compny_name as company,
        -- priority
        replace(priority, 'loow', 'Low') as priority

    from source

)

select * from renamed