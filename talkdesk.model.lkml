connection: "reporting02"

include: "*.view.lkml"


explore: calls_historical__account {
  label: "Team Performance"
  view_label: "Calls"

  always_filter: {
    filters: {
      field: calls_historical__account.call_finished_time
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
    sql_on: ${call_legs.interaction_id}=${calls_historical__account.id} ;;
  }
}

explore: users_account {
  label: "Agent Performance"
  view_label: "Users"

  always_filter: {
    filters: {
      field: calls_historical__agent.call_finished_time
      value: "2 days"
    }
  }
  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }

  join: calls_historical__agent {
    view_label: "Calls"
    type: left_outer
    relationship: one_to_many
    sql_on: ${users_account.user_id}=${calls_historical__agent.user_id} and ${users_account.account_id}=${calls_historical__agent.account_id};;
  }
}

explore: agent_status_historical {
  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }
}

explore: queue_metrics {
  access_filter: {
    field: account_id
    user_attribute: account_id_manual
  }
}
