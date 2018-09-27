view: calls_historical {
  sql_table_name: public.calls_historical ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: amount_billed {
    type: number
    sql: ${TABLE}.amount_billed ;;
  }

  dimension: call_disposition {
    type: string
    sql: ${TABLE}.call_disposition ;;
  }

  dimension: call_disposition_code {
    type: string
    sql: ${TABLE}.call_disposition_code ;;
  }

  dimension_group: call_finished {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.call_finished ;;
  }

  dimension: call_id {
    type: string
    sql: ${TABLE}.call_id ;;
  }

  dimension_group: call_started {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.call_started ;;
  }

  dimension: callback_from_queue {
    type: yesno
    sql: ${TABLE}.callback_from_queue ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }

  dimension: csat_score {
    type: number
    sql: ${TABLE}.csat_score ;;
  }

  dimension_group: csat_survey_sent {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.csat_survey_sent ;;
  }

  dimension: customer_phone_number {
    type: string
    sql: ${TABLE}.customer_phone_number ;;
  }

  dimension: direction {
    type: string
    sql: ${TABLE}.direction ;;
  }

  dimension: external_phone_number {
    type: string
    sql: ${TABLE}.external_phone_number ;;
  }

  dimension: false_abandoned_enabled {
    type: yesno
    sql: ${TABLE}.false_abandoned_enabled ;;
  }

  dimension: false_abandoned_threshold {
    type: number
    sql: ${TABLE}.false_abandoned_threshold ;;
  }

  dimension: hangup {
    type: string
    sql: ${TABLE}.hangup ;;
  }

  dimension: holding_time {
    type: number
    sql: ${TABLE}.holding_time ;;
  }

  dimension: in_business_hours {
    type: yesno
    sql: ${TABLE}.in_business_hours ;;
  }

  dimension: is_call_forwarding {
    type: yesno
    sql: ${TABLE}.is_call_forwarding ;;
  }

  dimension: is_external_transfer {
    type: yesno
    sql: ${TABLE}.is_external_transfer ;;
  }

  dimension: is_if_no_answer {
    type: yesno
    sql: ${TABLE}.is_if_no_answer ;;
  }

  dimension: ivr_responses {
    type: string
    sql: ${TABLE}.ivr_responses ;;
  }

  dimension: last_call_state {
    type: string
    sql: ${TABLE}.last_call_state ;;
  }

  dimension: minutes_billed {
    type: number
    sql: ${TABLE}.minutes_billed ;;
  }

  dimension: mood {
    type: string
    sql: ${TABLE}.mood ;;
  }

  dimension: mood_rendered {
    type: yesno
    sql: ${TABLE}.mood_rendered ;;
  }

  dimension: offered_teams {
    type: string
    sql: ${TABLE}.offered_teams ;;
  }

  dimension: previous_user_id {
    type: string
    sql: ${TABLE}.previous_user_id ;;
  }

  dimension: recording_url {
    type: string
    sql: ${TABLE}.recording_url ;;
  }

  dimension: ring_groups {
    type: string
    sql: ${TABLE}.ring_groups ;;
  }

  dimension: service_level_threshold {
    type: number
    sql: ${TABLE}.service_level_threshold ;;
  }

  dimension: speed_to_answer_time {
    type: number
    sql: ${TABLE}.speed_to_answer_time ;;
  }

  dimension: talk_time {
    type: number
    sql: ${TABLE}.talk_time ;;
  }

  dimension: talkdesk_phone_number {
    type: string
    sql: ${TABLE}.talkdesk_phone_number ;;
  }

  dimension: team_id {
    type: string
    sql: ${TABLE}.team_id ;;
  }

  dimension: total_duration {
    type: number
    sql: ${TABLE}.total_duration ;;
  }

  dimension: transfer_type {
    type: string
    sql: ${TABLE}.transfer_type ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: user_call_quality_rating {
    type: number
    sql: ${TABLE}.user_call_quality_rating ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_notes {
    type: string
    sql: ${TABLE}.user_notes ;;
  }

  dimension: waiting_time {
    type: number
    sql: ${TABLE}.waiting_time ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: total_waiting_time {
    type: sum
    sql: ${waiting_time} ;;
    value_format_name: decimal_2
    drill_fields: [detail*, total_waiting_time]
  }


  measure: average_waiting_time {
    type: average
    sql: ${waiting_time} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: longest_waiting_time {
    type: max
    sql: ${waiting_time} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: average_abandonment_time {
    type: average
    sql: ${TABLE}.total_duration ;;
    value_format_name: decimal_2
    filters: {
      field: direction
      value: "in"
    }
    filters: {
      field: type
      value: "abandoned"
    }
    drill_fields: [detail*]
  }

  measure: average_duration {
    type: average
    sql: ${TABLE}.total_duration ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: total_duration_measure {
    type: sum
    sql: ${TABLE}.total_duration ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: longest_duration {
    type: max
    sql: ${TABLE}.total_duration ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

#Service Level
  measure: service_level {
    type: number
    sql: (100.00 * COALESCE(${calls_with_waiting_time_less_that_service_level},0)) /NULLIF(${inbound_calls_during_business_hours_fm},0) ;;
    value_format: "#.00\%"
    drill_fields: [detail*]
  }

  measure: inbound_calls_during_business_hours_fm {
    hidden: yes
    type: count
    filters: {
      field: direction
      value: "in"
    }
    filters: {
      field: last_call_state
      value: "finished,missed"
    }
    filters: {
      field: in_business_hours
      value: "true"
    }
  }

  measure: calls_with_waiting_time_less_that_service_level {
    hidden: yes
    type: sum
    sql: CASE WHEN ${waiting_time} <= ${service_level_threshold} THEN 1 ELSE NULL END ;;
    filters: {
      field: direction
      value: "in"
    }
    filters: {
      field: last_call_state
      value: "finished,missed"
    }
    filters: {
      field: in_business_hours
      value: "true"
    }
  }


  set: detail {
    fields: [id, call_finished_date, direction, type]
  }
}
