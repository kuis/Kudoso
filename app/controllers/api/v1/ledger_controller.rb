module Api
  module V1
    class LedgerController < ApiController
      # This controller is only callable through the family and member
      # /api/v1/family/:family_id/members/:member_id/ledger

      resource_description do
        short 'API ledger '
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Ledger
          Ledger entries for the family member's kudos (bank)

        EOS
      end

      api :GET, "/v1/families/:family_id/members/:member_id/ledger", "Retrieve all ledger entries for a member (default: this month's entries)"
      param :start_date, Date, desc: "Optionaly specify a start date"
      param :end_date, Date, desc: "Optionaly specify an end date"
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == params[:member_id].to_i
            @member = @family.members.find(params[:member_id])
            params[:start_date] ||= 1.month.ago
            params[:end_date] ||= Date.today
            @ledger_entries = @member.ledger_entries.where(created_at: params[:start_date].beginning_of_day..params[:end_date].end_of_day)
            render :json => { ledger_entries: @ledger_entries.as_json, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

    end

  end
end
