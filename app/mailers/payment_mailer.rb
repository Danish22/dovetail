class PaymentMailer < ActionMailer::Base

  def invoice(user, member, invoice)
    @member = member
    @space = member.space
    @invoice = invoice

    host = ENV["PORTAL_BASE_HOST"] || Rails.application.config.action_mailer.default_url_options[:host]
    @needs_account = (@member.uid.blank? && @member.provider.blank?)
    if @needs_account
      @member.invite = Digest::SHA1.hexdigest([@member.space.id, Time.now, rand].join)  # Member gets saved by the caller...
      @url = portal_account_url(host: host, subdomain: @member.space.subdomain, invite: @member.invite)      
    else
      @url = portal_account_url(host: host, subdomain: @member.space.subdomain)      
    end

    mail(to: @member.email, 
         from: user.email,
         subject: "#{@space.name} - Invoice (Ref. No. #{sprintf("%05d", @invoice.id)})"
         )
  end

  def payment(user, member, payment, url, needs_account)
    @member = member
    @space = member.space
    @url = url
    @payment = payment
    @needs_account = needs_account

    mail(to: @member.email, 
         from: user.email,
         subject: "Payment to #{@space.name}"
         )
  end

end
