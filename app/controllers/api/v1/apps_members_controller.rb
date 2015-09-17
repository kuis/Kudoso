module Api
  module V1
    class AppsMembersController < ApiController

      resource_description do
        short 'Apps'
        formats ['json']
        api_version "v1"
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == Apps
          Used for registering and tracking application restrictions for a member
        EOS
      end

      api :GET, "/v1/family/<family_id>/members/<member_id>/apps", "Get list of app restrctions for the member"
      api :GET, "/v1/family/<family_id>/devices/<device_id>/members/<member_id>/apps", "Get list of apps & restrictions on device for the member."

      def index
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent )
            if params[:device_id]
              @device = @family.devices.find(params[:device_id])
              @apps = @member.app_members.includes(:devices).where('app_devices.device_id' => @device.id)
            else
              @apps = @member.app_members
            end
            render :json => { apps: @apps, :messages => messages }, :status => 200
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

      api :POST, "/v1/family/<family_id>/devices/<device_id>/apps", "Update application(s) restrictions for member"
      param :app, Hash, desc: "App object consisting of (uuid & restricted are required): { 'app' : { 'uuid' : 'com.kudoso.Kudoso', 'restricted' : true } "
      param :apps, Array, desc: "Array of app objects"
      def create
        messages = init_messages
        begin
          @family = Family.find(params[:family_id])
          @member = @family.members.find(params[:member_id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family && @current_member.parent )
            good = true
            if params[:apps] && params[:apps].is_a?(Array)
              params[:apps].each { |app| good = add_app(app, @member) && good }
            else
              good = add_app(params[:app], @member) && good
            end
            if good
              render :json => { apps: @member.app_members, :messages => messages }, :status => 200
            else
              messages[:error] << 'Unable to add application record'
              render :json => { :messages => messages }, :status => 400
            end

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

      private

      def add_app(new_app, member)
        return false if member.nil? || !new_app.is_a?(Hash)
        begin
          app = App.find_by(uuid: new_app[:uuid])
          app_member = AppMember.find_or_create_by(app_id: app.id, member_id: member.id)
          if app_member.valid?
            if app_member.update_attribute(:restricted, !!new_app[:restricted] )
              return true
            else
              return false
            end
          else
            return false
          end
        rescue
          return false
        end

      end


    end
  end
end