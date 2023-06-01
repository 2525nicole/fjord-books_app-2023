#frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase

  setup do
    @report = reports(:one)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    click_on '日報'
  end

  test 'visiting the index' do
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text "Alice'sReport"
    assert_text 'http://localhost:3000/reports/2'

    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: '更新する内容'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text "Alice'sReport"
    assert_text '更新する内容'

    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
  end
end
