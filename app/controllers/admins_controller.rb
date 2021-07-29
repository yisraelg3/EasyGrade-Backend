class AdminsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :display_errors
rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :authorized_admin, only: [:index, :me]
    def create
        new_admin = Admin.create!(admin_params)
        new_admin.create_default
        token = encode_token({user_id: new_admin.id, class: "Admin"})
        render json: {user: AdminSerializer.new(new_admin), token: token}
    end

    def index
        render json: @admin
    end

    def login
        # byebug
        admin = Admin.find_by(username: params[:username])
        if admin && admin.authenticate(params[:password])
            wristband = encode_token({user_id: admin.id, class: 'Admin'})
            render json: {user: AdminSerializer.new(admin), token: wristband}
        else
            render json: {errors: "wrong username or password"}
        end
    end

    def me
        wristband = encode_token({user_id: @admin.id, class: 'Admin'})
        render json: {user: AdminSerializer.new(@admin), token: wristband}
    end

    private
    def admin_params
        params.permit(:username, :password, :title, :first_name, :last_name)
    end

    def display_errors(i)
        render json: {errors: i.record.errors.full_messages}, status: :unprocessable_entity
    end

    def not_found
        render json: {errors: 'Admin user not found'}, status: :not_found
    end
end
