module Api
  module V1
    class FamiliesController < ApiController

      resource_description do
        short 'API Families'
        formats ['json']
        api_version "v1"
        error code: 401, desc: 'Unauthorized'
        error 404, "Missing"
        error 500, "Server processing error (check messages object)"
        description <<-EOS
          == API Families
          Once authenticated, you can retrieve Family specific information including default
          protection settings (screen time and content filtering).

        EOS
      end

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

      api :GET, "/api/v1/families/:family_id", "Retrieve family information"
      example '  {"id"=>1, "name"=>"Test Family", "primary_contact_id"=>3, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:23 MDT -06:00, "memorialized_date"=>Wed, 01 Jul 2015, "timezone"=>nil, "default_screen_time"=>2, "default_filter"=>"strict", "secure_key"=>"oz3zBBWWqpJAshu/S3ZgmA==", "device_categories"=>{"device_category_1"=>{:amount=>2, "device_category_name"=>"Mobile Devices"}, "device_category_2"=>{:amount=>1, "device_category_name"=>"Computers"}, "device_category_3"=>{:amount=>2, "device_category_name"=>"Game Consoles"}, "device_category_4"=>{:amount=>2, "device_category_name"=>"Video Devices"}}}  '

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

      api :PATCH, "/api/v1/families/:family_id", "Update family information"
      param :name, String, desc: 'The family name'
      param :default_time, Integer, desc: 'Default screen time per day (in minutes)'
      param :default_filter, [ 'strict', 'moderate', 'mature', 'monitor'], desc: 'Default content filtering for new family members'
      param :device_categories, Hash, desc: 'Hash containing device category IDs as the key, and the number of devices as the value; ex: {"device_category_1" : 2, "device_category_2" : 1}'
      example '  {"id"=>1, "name"=>"Test Family", "primary_contact_id"=>3, "created_at"=>Thu, 02 Jul 2015 10:15:52 MDT -06:00, "updated_at"=>Thu, 02 Jul 2015 10:22:23 MDT -06:00, "memorialized_date"=>Wed, 01 Jul 2015, "timezone"=>nil, "default_screen_time"=>2, "default_filter"=>"strict", "secure_key"=>"oz3zBBWWqpJAshu/S3ZgmA==", "device_categories"=>{"device_category_1"=>{:amount=>2, "device_category_name"=>"Mobile Devices"}, "device_category_2"=>{:amount=>1, "device_category_name"=>"Computers"}, "device_category_3"=>{:amount=>2, "device_category_name"=>"Game Consoles"}, "device_category_4"=>{:amount=>2, "device_category_name"=>"Video Devices"}}}  '

      def update
        messages = init_messages
        begin
          @family = Family.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.default_screen_time = params["default_time"].to_i if params["default_time"]
            @family.default_filter = params["default_filter"].downcase if params["default_filter"]
            @family.name = params["name"] if params["name"]
            if params[ "device_categories" ].present? &&  params[ "device_categories" ].is_a?(Hash)
              params[ "device_categories" ].each do |key, value|
                unless key.ends_with?('_other')
                  id = "#{key}"
                  id.slice!('device_category_')
                  device_category = FamilyDeviceCategory.find_or_create_by(device_category_id: id.to_i, family_id: @family.id)
                  if value.to_i != 4
                    device_category.amount = value.to_i
                  else
                    device_category.amount = params[ "device_categories" ][ "device_category_#{id}_other"].to_i
                  end
                  device_category.save
                  logger.info "Saved device category: #{device_category.inspect}"
                end
              end
            end

            if @family.save
              render :json => { :family => @family, :messages => messages }, :status => 200
            else
              @family.errors.each do |err|
                messages[:error] << err
              end
              render :json => { :family => @family, :messages => messages }, :status => 409
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
    end
  end
end
