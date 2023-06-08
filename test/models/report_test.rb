# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:one)
  end

  test 'editable?' do
    target_user = users(:alice)
    assert @report.editable?(target_user)

    target_user = users(:bob)
    assert_not @report.editable?(target_user)
  end

  test 'created_on' do
    @report.created_at = Time.zone.parse('2023-01-01')
    assert_equal Date.new(2023, 1, 1), @report.created_on
  end

  test 'save_mentions' do
    assert_changes -> { @report.mentioning_report_ids }, from: [2], to: [3, 4] do
      @report.content = 'http://localhost:3000/reports/1,http://localhost:3000/reports/3,http://localhost:3000/reports/4'
      @report.send(:save_mentions)
    end
  end
end
