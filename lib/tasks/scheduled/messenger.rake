namespace :scheduled do

  desc 'Create Messenger Post'
  task create_messenger_post: :environment do

    ARGV.each { |a| task a.to_sym do ; end }

    # rails c
    # Rails.application.load_tasks
    # Rake::Task['scheduled:create_messenger_post'].invoke
    # heroku run rake scheduled:create_messenger_post 60 100 -a imgraetzl-staging
    user_range_start = ARGV[1].to_i
    user_range_end = ARGV[2].to_i

    sender = User.where("email" => "wir@imgraetzl.at").last

    User.where(id: user_range_start..user_range_end).each do |user|
      next if user.id == sender.id
      thread = UserMessageThread.create_general(sender, user)
      user_message = thread.user_messages.create(user: sender, message: chat_message(user))

      thread.user_message_thread_members.where(
        user_id: sender.id
      ).where(
        "last_message_seen_id < ?", user_message.id
      ).update_all(
        last_message_seen_id: user_message.id
      )

    end

  end

  def chat_message(user)

  "Servus #{user.first_name},\r\n\r\nbei uns ist etwas Großartiges passiert: Wir haben am 12. Jänner eine Crowdfunding-Kampagne gestartet, weil wir mit imGrätzl auf’s Land wollen. Innerhalb der ersten 48 Stunden haben wir mit unserer grandiosen Community (also euch!) das Funding-Ziel erreicht :)\r\n\r\nDiese Unterstützung einmal selber erleben zu dürfen, hat uns umgehauen und dafür sind wir sehr dankbar.\r\n\r\nWeil wir das so schnell geschafft haben, ist es möglich auch imGrätzl in Wien abzusichern – und dafür brauchen wir deine Unterstützung! Die Crowdfunding-Kampagne läuft jetzt nur noch wenige Tage, die Chance ist da.\r\n\r\nMit zusätzlichem Geld könnten wir die monatlichen Rechnungen für den Plattform-Betrieb begleichen und wir hätten den Rückenwind, um viele Ideen und Vorschläge in Wien umzusetzen.\r\n\r\nJede Form der Unterstützung bringt uns nach vorne: Teilen, posten, weitersagen – und wer kann, natürlich auch spenden.\r\nBei unseren Dankeschöns ist bestimmt etwas für dich dabei: https://www.startnext.com/imgraetzl-kommt-zu-euch\r\n\r\nWenn jetzt jeder mithilft, schaffen wir das!\r\n\r\nDanke, für's Träume möglich machen,\r\neuer imGrätzl Team\r\nMirjam, Lena, Michael\r\n\r\nPS: im Messenger könnt ihr uns direkt auch Fragen dazu stellen!"

  end

end
