module Api
  module V1
    class MembersController < ApiController

      skip_before_filter :restrict_api_access,  if: :check_for_auth

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

          Member object returns as JSON with embedded Theme object.

        EOS
      end
      def_param_group :member do
        param :first_name, String
        param :username, String, desc: "The username is used for logging in the member, this should in most cases just be the member's first name"
        param :birth_date, String, desc: "The member's birth date in MM/DD/YYYY format"
        param :email, String, desc: "Optionally define an email address for this member (useful for notifications and updates)"
        param :parent, [true, false], desc: "Set to true if this member is a parent in the family (default: false)"
        param :gender, ['m', 'f'], desc: "Gender of member as (m)ale or (f)emale"
        param :password, String, desc: "Member's password"
        param :password_confirmation, String, desc: "Member's password, confirmed"
      end

      api :GET, "/v1/families/:family_id/members", "Retrieve all family members (authenticated user must be a parent to retreive all info)"
      example '  [{"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}, {"id"=>1, "username"=>"parent@kudoso.com", "birth_date"=>nil, "parent"=>true, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:08 MDT -06:00, "kudos"=>0, "authentication_token"=>nil, "first_name"=>"Parent", "last_name"=>"Test", "email"=>"parent@kudoso.com", "mobicip_profile"=>nil}, {"id"=>4, "username"=>"timmy", "birth_date"=>Sat, 08 Mar 2003, "parent"=>false, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:22:45 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:45 MDT -06:00, "kudos"=>0, "authentication_token"=>nil, "first_name"=>"Timmy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}, {"id"=>2, "username"=>"johnny", "birth_date"=>Sat, 02 Jul 2005, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:01 MDT -06:00, "kudos"=>1420, "authentication_token"=>nil, "first_name"=>"Johnny", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil}]  '
      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @members = @family.members
          if @current_user && ( @current_user.admin? || @current_user.family == @family)
            render :json => { :members => @members.as_json, :messages => messages }, :status => 200
          else
            if params[:secure_key] == @family.secure_key
              render :json => { :members => @members.as_json(only: [:username, :parent, :first_name], include: :theme, methods: :avatar_urls), :messages => messages }, :status => 200
            else
              messages[:error] << 'Authorization failed'
              render :json => { :messages => messages }, :status => 403
            end

          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end
      end

      api :GET, "/v1/families/:family_id/members/:member_id", "Retrieve a specic member (authenticated user must be a parent or the specific member)"
      example '  {"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil} '
      def show
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            @member = @family.members.find(params[:id])
            render :json => { :member => @member.as_json, :messages => messages }, :status => 200
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

      api :POST, "/v1/families/:family_id/members", "Create a new family member (authenticated user must be a parent)"
      param_group :member
      example '  {"id"=>3, "username"=>"suzy", "birth_date"=>Thu, 02 Jul 2009, "parent"=>nil, "family_id"=>1, "contact_id"=>nil, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:16:02 MDT -06:00, "kudos"=>1200, "authentication_token"=>nil, "first_name"=>"Suzy", "last_name"=>"Test", "email"=>nil, "mobicip_profile"=>nil} '
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family )
            local_params = member_create_params.merge(family_id: @family.id)
            local_params[:birth_date] = Chronic.parse(local_params[:birth_date]).to_date.to_s(:db) if local_params[:birth_date]
            @member = Member.create(local_params)
            @member.password = local_params[:password] if local_params[:password]
            @member.password_confirmation = local_params[:password_confirmation] if local_params[:password_confirmation]
            if @member.save
              render :json => { :member => @member.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @member.errors.full_messages
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

      api :PATCH, "/v1/families/:family_id/members/:member_id", "Update a family member (authenticated user must be a parent or the specific member)"
      param_group :member
      def update
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent ) || @current_member.id == params[:id].to_i
            @member = @family.members.find(params[:id])
            local_params = member_create_params.merge(family_id: @family.id)
            local_params[:birth_date] = Chronic.parse(local_params[:birth_date]).to_date.to_s(:db) if local_params[:birth_date]
            if local_params[:avatar]
              @member.avatar = parse_image_data(local_params[:avatar])
              @member.save
              local_params.delete(:avatar)
            end

            if @member.update_attributes(local_params)
              render :json => { :member => @member.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @member.errors.full_messages
              render :json => { :member => @member.as_json, :messages => messages }, :status => 400
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

      api :DELETE, "/v1/families/:family_id/members/:member_id", "Delete a family member (authenticated user must be a parent)"
      param_group :member
      def destroy
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent )
            @member = @family.members.find(params[:id])
            if @member.destroy
              render :json => { :member => @member.as_json, :messages => messages }, :status => 200
            else
              messages[:error].concat @member.errors.full_messages
              render :json => { :member => @member.as_json, :messages => messages }, :status => 400
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


      api :POST, "/v1/families/:family_id/members/:member_id/buy_screen_time", "Buy additional screen time"
      param :time, Integer, desc: "Time (in seconds) to buy, if nil will attempt to buy maximum amount", required: false
      def buy_screen_time
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.id == params[:id].to_i )
            @member = @family.members.find(params[:id])
            time = params[:time].try(:to_i)
            begin
              @member.buy_screen_time(time)
            rescue  ScreenTime::ScreenTimeExceeded
              messages[:error] << 'Sorry, maximum screen time for today already used'
            rescue  Member::NotEnoughKudos
              messages[:error] << 'Sorry, you do not have enough kudos to buy this much time'
            rescue
              messages[:error] << 'Failed to buy screen time'
            end
            render :json => { :member => @member.as_json, :messages => messages }, :status => messages[:error].length > 0 ? 400 : 200
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
        params.require(:member).permit(:username, :parent, :password, :password_confirmation, :birth_date, :first_name, :last_name, :gender, :email, :theme_id, avatar: %w(content-type content))
      end

      def check_for_auth
        action_name == "index" && request.headers["HTTP_AUTHORIZATION"].nil?
      end


    end

  end
end
