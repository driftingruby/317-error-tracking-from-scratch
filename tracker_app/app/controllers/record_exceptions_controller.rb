class RecordExceptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.cache.write((Time.current.to_f * 1000), payload)
    head :ok
  end

  private

  def payload
    {
      message: params[:message],
      backtrace: params[:backtrace],
      method: params[:method],
      uri: params[:uri],
      source_location: params[:source_location]
    }.to_json
  end
end