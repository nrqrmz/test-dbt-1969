with 

source as (

    select * from {{ source('circle', 'funnel') }}

),

renamed as (

    select
        company,
        sector,
        date_lead,
        opportunity_date as date_opportunity,
        cast(date_customer as date) as date_customer,
        date_lost

    from source

)

select * from renamed
