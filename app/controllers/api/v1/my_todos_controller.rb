module Api
  module V1
    class MyTodosController < ApiController
      # This controller is only callable through the family and member
      # /api/v1/family/:family_id/members/:member_id/my_todos
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == params[:id]
            @member = @family.members.find(params[:member_id])
            render :json => { my_todos: @member.todos, :messages => messages }, :status => 200
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
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @current_member.id == @my_todo.member_id
            render :json => { :my_todo => @my_todo, :messages => messages }, :status => 200
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
          @member = @family.members.find(params[:member_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member
            @my_todo = @member.my_todos.create(my_todo_create_params)
            if @my_todo.valid?
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 200
            else
              messages[:error] << @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 400
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

      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) ) || @member == @current_member
            if @my_todo.update_attributes(my_todo_create_params)
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 200
            else
              messages[:error] << @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 400
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

      def verify
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          @my_todo = @member.my_todos.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.try(:parent) )
            if @my_todo.verify!(@current_member)
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 200
            else
              messages[:error] << @my_todo.errors.full_messages
              render :json => { :my_todo => @my_todo, :messages => messages }, :status => 400
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
      def my_todo_create_params
        params.require(:my_todo).permit(:due_date, :due_time, :complete, :verify, :todo_schedule_id)
      end

    end

  end
end
