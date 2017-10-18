class EvaluationController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    begin
      model = EvaluationNewsletter.where(newsletter_id: params['newsletter_id'], event_identifier: params['event_identifier']).first

      if model
        model.update(response_counter: model.response_counter + 1)
      else
        data = {
            newsletter_id: params['newsletter_id'].to_i,
            response_counter: 1,
            action_datetime: DateTime.now,
            user_response_type: params['user_response_type'].try(:to_s),
            user_response_detail: params['user_response_details'].try(:to_s),
            content_type: params['content_type'].try(:to_s),
            content_detail: params['content_detail'].try(:to_s),
            event_identifier: params['event_identifier']
        }

        EvaluationNewsletter.create!(data)
      end
    rescue Exception => e
      ErrorReporter.report(:error, e, "#{klass_error_msg} - Error saving Evaluation model to DB!")
    end

    params['redirect_to'] ? redirect_to(params['redirect_to']) : head(200)
  end
end