module Api
  module V1
    class MembersController < ApiController
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user && ( @current_user.admin? || @current_user.family == @family)
            @members = @family.members
            render :json => { :members => @members, :messages => messages }, :status => 200
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

      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            @member = @family.members.find(params[:id])
            render :json => { :member => member, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family or Member not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            local_params = member_create_params.merge(family_id: @family.id)
            logger.info local_params.inspect
            local_params[:birth_date] = Chronic.parse(local_params[:birth_date]).to_date.to_s(:db) if local_params[:birth_date]
            @member = Member.new(local_params)
            if @member.save
              render :json => { :member => @member, :messages => messages }, :status => 200
            else
              messages[:error] << @member.errors.full_messages
              render :json => { :member => @member, :messages => messages }, :status => 400
            end

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

      private


      # Never trust parameters from the scary internet, only allow the white list through.
      def member_create_params
        params.require(:member).permit(:username, :parent, :password, :password_confirmation, :birth_date, :first_name, :last_name, :email)
      end

    end

  end
end
