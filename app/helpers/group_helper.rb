module GroupHelper

  def can_view_classified_info
    @group_custom_data.get('view_classified_info') == "true" ? "TRUE" : "FALSE"
  end

  def can_delete_others
    @group_custom_data.get('delete_others') == "true" ? "TRUE" : "FALSE"
  end

end