
include: "calls_historical__base.view"
view: calls_historical__agent {
  extends: [calls_historical__base]

  dimension: user_call_quality_rating {
    type: number
    sql: ${TABLE}.user_call_quality_rating ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_notes {
    hidden: yes
    type: string
    sql: ${TABLE}.user_notes ;;
  }

  dimension: previous_user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.previous_user_id ;;
  }


}
