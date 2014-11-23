class InvitesMailer < ActionMailer::Base

  def new_user_invite(invite, invite_url)
    @url  = invite_url
    @invite = invite
    @space = invite.space

    mail(to: @invite.email, 
         from: @invite.sender.email,
         subject: "Invitation to join Dovetail"
         )
  end

  def existing_user_invite(invite, space_url)
    @invite = invite
    @space = invite.space
    @url  = space_url

    mail(to: @invite.recipient.email, 
         from: @invite.sender.email,
         subject: "Added as as admin on Dovetail"
         )
  end

  def member_invite(user, member, url)
    @member = member
    @space = member.space
    @url = url

    mail(to: @member.email, 
         from: user.email,
         subject: "Invitation to sign up for #{@space.name}"
         )
  end
end
