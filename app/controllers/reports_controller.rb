# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioned_reports = @report.mentioned_reports.order(created_at: :desc, id: :desc).includes(:user)
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    ActiveRecord::Base.transaction do
      @report = current_user.reports.new(report_params)
      saveable_report = @report.save
      unless saveable_report
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      @report.contained_report_id.each do |r|
        @mention = @report.create_mention(r)
        @mention.save!
      end

      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    end
  end

  def update
    mentions_before_update = @report.mentioning_reports

    ActiveRecord::Base.transaction do
      updatable_report = @report.update(report_params)
      unless updatable_report
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      mentions_before_update.each do |m|
        destruction_target = Mention.find_by!(mentioning_report_id: @report.id, mentioned_report_id: m)
        destruction_target.destroy!
      end

      @report.contained_report_id.each do |r|
        @mention = @report.create_mention(r)
        @mention.save!
      end

      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
