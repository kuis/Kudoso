module Api
  module V1
    class TodoTemplatesController < ApiController
      def index
        messages = init_messages

        @todo_templates = TodoTemplate.all
        render :json => { :todo_templates => @todo_templates, :messages => messages }, :status => 200

      end

      def show
        messages = init_messages
        begin
          @todo_template = TodoTemplate.find(params[:id])
          render :json => { :todo_template => @todo_template, :messages => messages }, :status => 200


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      def assign
        messages = init_messages
        begin
          @todo_template = TodoTemplate.find(params[:id])
          @family = Family.find(params[:family_id])
          @member = Member.find(params[:member_id])

          if @family && @member && @todo_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.assign_template(@todo_template, [ @member ])
            render :json => { :messages => messages }, :status => 200
          end


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      def unassign
        messages = init_messages
        begin
          @todo_template = TodoTemplate.find(params[:id])
          @family = Family.find(params[:family_id])
          @member = Member.find(params[:member_id])

          if @family && @member && @todo_template && @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.remove_template(@todo_template, [ @member ])
            render :json => { :messages => messages }, :status => 200
          end


        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Record not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

    end
  end
end
