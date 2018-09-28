connection: "reporting02"

include: "*.view.lkml"


explore: calls_historical {
  always_filter: {
    filters: {
      field: calls_historical.call_finished_date
      value: "2 days"
    }
  }
  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }
  join: call_legs {
    type: left_outer
    relationship: one_to_many
    sql_on: ${call_legs.interaction_id}=${calls_historical.id} ;;
  }
}
