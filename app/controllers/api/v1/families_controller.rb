module Api
  module V1
    class FamiliesController < ApiController
      def index
        messages = init_messages
        if @current_user && @current_user.admin?
          @families = Family.all
          render :json => { :families => @families, :messages => messages }, :status => 200
        else
          messages[:error] << 'You are not authorized to do this.'
          render :json => { :messages => messages }, :status => 403
        end
      end

      def show
        messages = init_messages
        begin
          @family = Family.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family)
            render :json => { :family => @family, :messages => messages }, :status => 200
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
