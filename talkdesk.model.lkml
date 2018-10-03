connection: "reporting02"

include: "*.view.lkml"


explore: calls_historical {

  always_filter: {
    filters: {
      field: calls_historical.call_finished_time
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

explore: users_account {

  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }

  join: calls_historical{
    type: left_outer
    relationship: one_to_many
    sql_on: ${users_account.user_id}=${calls_historical.user_id} and ${users_account.account_id}=${calls_historical.account_id};;
  }
}

explore: agent_status_historical {
  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }
}
