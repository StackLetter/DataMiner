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
            user_response_detail: params['user_response_detail'].try(:to_s),
            content_type: params['content_type'].try(:to_s),
            content_detail: params['content_detail'].try(:to_s),
            event_identifier: params['event_identifier']
        }

        EvaluationNewsletter.create!(data)
      end

      # Bandit reward change
      content_type = params['content_type'].try(:to_s)
      if content_type == 'section'
        value = (content_type == 'section' ? 2 : 1)
        value *= params['user_response_detail'].try(:to_i)

        user = Newsletter.find(params['newsletter_id']).user
        newsletter_section = NewsletterSection.find(params['content_detail'].try(:to_s))
        sections = MsaSection.where(name: newsletter_section.name)

        BanditJobs::RewardsUpdateJob.perform_later(user.segment_id, sections.first.id, value) if sections.size == 1
      end
    rescue Exception => e
      ErrorReporter.report(:error, e, "#{klass_error_msg} - Error saving Evaluation model to DB!")
    end

    params['redirect_to'] ? redirect_to(URI.decode(params['redirect_to'])) : head(200)
  end
end