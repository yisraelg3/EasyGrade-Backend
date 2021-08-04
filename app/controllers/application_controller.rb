class ApplicationController < ActionController::API

    def encode_token(payload)
        # byebug
        JWT.encode(payload, "yisraelGurkow")
    end

    def auth_header
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header 
            token = auth_header.split(" ")[1]
            begin
                JWT.decode(token, "yisraelGurkow", true)
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def current_user
        # byebug
        if decoded_token && decoded_token[0]['user_id'] && decoded_token[0]['class']
            user_id = decoded_token[0]['user_id']
            if decoded_token[0]['class'] == "Admin"
                @admin = Admin.includes(:klasses, :students, :teachers, :grade_categories).find_by({id: user_id})
                @user = @admin
            elsif decoded_token[0]['class'] == "Teacher"
                @teacher = Teacher.includes(:klasses, :students).find_by({id: user_id})
                @user = @teacher
            elsif decoded_token[0]['class'] == "Parent"
                @parent = Parent.includes(:students).find_by({id: user_id})
                @user = @parent
            else 
                nil
            end
        end
    end

    def logged_in?
        !!current_user
    end

    def authorized
        render json: {errors: "Please log in"}, status: :unauthorized unless logged_in?
    end

    def authorized_admin
        render json: {errors: "Unauthorized"}, status: :unauthorized unless logged_in? && @admin
    end

    def authorized_admin_or_teacher
        render json: {errors: "Unauthorized"}, status: :unauthorized unless logged_in? && (@admin || @teacher)
    end
end
