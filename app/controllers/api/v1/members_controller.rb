module Api
  module V1
    class MembersController < ApiController

      resource_description do
        short 'API Members'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Members
          Once authenticated, you can retrieve Member specific information.

        EOS
      end
      def_param_group :member do
        param :first_name, String, required: true
        param :username, String, desc: "The username is used for logging in the member, this should in most cases just be the member's first name", required: true
        param :birth_date, String, desc: "The member's birth date in MM/DD/YYYY format", required: true
        param :email, String, desc: "Optionally define an email address for this member (useful for notifications and updates)"
        param :parent, [true, false], desc: "Set to true if this member is a parent in the family (default: false)"
      end

      api :GET, "/api/v1/families/:family_id/members", "Retrieve all family members (authenticated user must be a parent)"
      example '  [{"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}, {"id"=>1, "username"=>"parent@kudoso.com", "birth_date"=>nil, "parent"=>true, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:08 MDT -06:00, "kudos"=>0, "authentication_token"=>nil, "first_name"=>"Parent", "last_name"=>"Test", "email"=>"parent@kudoso.com", "mobicip_profile"=>nil}, {"id"=>4, "username"=>"timmy", "birth_date"=>Sat, 08 Mar 2003, "parent"=>false, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:22:45 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:45 MDT -06:00, "kudos"=>0, "authentication_token"=>nil, "first_name"=>"Timmy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}, {"id"=>2, "username"=>"johnny", "birth_date"=>Sat, 02 Jul 2005, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:01 MDT -06:00, "kudos"=>1420, "authentication_token"=>nil, "first_name"=>"Johnny", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}]  '
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

      api :GET, "/api/v1/families/:family_id/members/:member_id", "Retrieve a specic member (authenticated user must be a parent or the specific member)"
      example '  {"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil} '
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            @member = @family.members.find(params[:id])
            render :json => { :member => @member, :messages => messages }, :status => 200
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

      api :POST, "/api/v1/families/:family_id/members", "Create a new family member (authenticated user must be a parent)"
      param_group :member
      example '  {"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil} '
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            local_params = member_create_params.merge(family_id: @family.id)
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

      api :PATCH, "/api/v1/families/:family_id/members/:member_id", "Update a family member (authenticated user must be a parent or the specific member)"
      param_group :member
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent ) || @current_member.id == params[:id]
            @member = @family.members.find(params[:id])
            local_params = member_create_params.merge(family_id: @family.id)
            local_params[:birth_date] = Chronic.parse(local_params[:birth_date]).to_date.to_s(:db) if local_params[:birth_date]

            if @member.update_attributes(local_params)
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

      api :DELETE, "/api/v1/families/:family_id/members/:member_id", "Delete a family member (authenticated user must be a parent)"
      param_group :member
      def destroy
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent )
            @member = @family.members.find(params[:id])
            if @member.destroy
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
