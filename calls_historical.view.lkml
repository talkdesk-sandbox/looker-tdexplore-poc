view: calls_historical {
  sql_table_name: public.calls_historical ;;

  # Dimensions
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
      minute,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.call_finished ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    description: "Use this with Call Finished Dynamic dimension"
    type: string
    allowed_value: { value: "Month" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Minute" }
    default_value: "Hour"
  }

  dimension: call_finished_dynamic_v1 {
    description: "Use this with Date Granularity filter"
    type: date_time
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN DATE_TRUNC('month', ${call_finished_raw})
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  ${call_finished_date}
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN DATE_TRUNC('hour', ${call_finished_raw})
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN DATE_TRUNC('minute', ${call_finished_raw})
    END ;;
  }

  dimension: call_finished_dynamic_v2 {
    description: "Use this with Date Granularity filter"
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN ${call_finished_month}
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  TO_CHAR(${call_finished_date}, 'YYYY-MM-DD')
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN ${custom_hour_of_day}
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN ${call_finished_minute}
    END ;;
  }

  dimension: custom_hour_of_day {
#       hidden: yes
  description: "Need to do this so it orders correctly when the dynamic timeframe is used in a report."
  sql: CASE
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 0 then '00'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 1 then '01'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 2 then '02'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 3 then '03'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 4 then '04'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 5 then '05'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 6 then '06'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 7 then '07'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 8 then '08'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 9 then '09'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 10 then '10'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 11 then '11'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 12 then '12'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 13 then '13'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 14 then '14'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 15 then '15'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 16 then '16'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 17 then '17'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 18 then '18'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 19 then '19'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 20 then '20'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 21 then '21'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 22 then '22'
          WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 23 then '23'
        END
        ;;
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
    hidden: yes
    type: string
    sql: ${TABLE}.direction ;;
  }

dimension: calls_direction {
    type: string
    sql: CASE
        WHEN ${direction} = 'in' THEN 'Inbound'
        WHEN ${direction} = 'out' THEN 'Outbound'
        WHEN ${direction} = 'agent' THEN 'Agent-to-Agent'
      ELSE NULL END
      ;;
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
  sql: initcap(cast(${TABLE}.last_call_state as varchar)) ;;
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

# Measures
measure: total_calls_count {
  type: count
  drill_fields: [id]
}

measure: inbound_calls_count {
  type: count
  filters: {
    field: direction
    value: "in"
  }
}

measure: outbound_calls_count {
  type: count
  filters: {
    field: direction
    value: "out"
  }
}

#https://discourse.looker.com/t/readable-times-from-seconds/1587/5
measure: total_waiting_time {
  type: sum
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*, total_waiting_time]
}

measure: average_waiting_time {
  type: average
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_waiting_time {
  type: max
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: average_abandonment_time {
  type: average
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  filters: {
    field: last_call_state
    value: "Abandoned"
  }
  drill_fields: [detail*]
}

measure: average_duration {
  type: average
  sql: ${total_duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: total_duration_measure {
  type: sum
  sql: ${total_duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_duration {
  type: max
  sql: ${total_duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: speed_to_answer {
  type: sum
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: average_speed_to_answer {
  type: average
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_speed_to_answer {
  type: max
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

#Service Level
measure: service_level {
  type: number
  sql: (100.00 * COALESCE(${calls_with_waiting_time_less_that_service_level},0)) /NULLIF(${inbound_calls_during_business_hours_fm},0) ;;
  value_format: "#.00\%"
  drill_fields: [detail*]
  html:   <img src="https://chart.googleapis.com/chart?chs=400x250&cht=gom&chma=10,0,0,0&chxt=y&chco=FF4E00,191F43,01C6CC&chf=bg,s,FFFFFF00&chl={{ rendered_value }}&chd=t:{{ value }}">;;
  # https://discourse.looker.com/t/creating-custom-vis-via-html/3735
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
    value: "Finished,Missed"
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
    value: "Finished,Missed"
  }
  filters: {
    field: in_business_hours
    value: "true"
  }
}

# Details Set
set: detail {
  fields: [id, call_finished_date, direction, type]
}
}
