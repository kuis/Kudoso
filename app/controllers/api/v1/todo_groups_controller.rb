module Api
  module V1
    class TodoGroupsController < ApiController
      def index
        messages = init_messages

        @todo_groups = TodoGroup.active
        render :json => { :todo_groups => @todo_groups, :messages => messages }, :status => 200

      end

      def show
        messages = init_messages
        begin
          @todo_group = TodoGroup.includes(:todo_templates).find(params[:id])
          render :json => { :todo_group => @todo_group.as_json({ include: :todo_templates }), :messages => messages }, :status => 200


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
