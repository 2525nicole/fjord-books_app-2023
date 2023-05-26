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

      @report.create_mention(@report.contained_report_id)

      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    end
  end

  def update
    mention_ids = @report.mentioning_reports

    ActiveRecord::Base.transaction do
      unless @report.update(report_params)
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      mention_ids.each do |m|
        destruction_target = @report.mentioning_relationships.find_by!(mentioned_report_id: m)
        destruction_target.destroy!
      end

      @report.create_mention(@report.contained_report_id)

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
