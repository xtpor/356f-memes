defmodule Memes.Rpc.Admin do
  alias Memes.Repo
  import Memes.Rpc.Utils
  import Ecto.Query, only: [select: 2, where: 3]

  def submit_report(name, email, subject, content)
      when is_binary(name) and is_binary(email) and is_binary(subject) and
           is_binary(content) do

    Repo.insert_all("report_forms", [[name: name, email: email,
                                    subject: subject, content: content]])
    ok()
  end

  def submit_help(name, email, subject, content)
      when is_binary(name) and is_binary(email) and is_binary(subject) and
           is_binary(content) do
    Repo.insert_all("help_forms", [[name: name, email: email,
                                      subject: subject, content: content]])
    ok()
  end

  def fetch_helps(token) when is_binary(token) do
    login_as_admin!(token)

    "help_forms"
    |> select([:id, :name, :email, :subject, :content])
    |> Repo.all
    |> ok
  end

  def fetch_reports(token) when is_binary(token) do
    login_as_admin!(token)

    "report_forms"
    |> select([:id, :name, :email, :subject, :content])
    |> Repo.all
    |> ok
  end

  def delete_help(token, id) when is_binary(token) and is_integer(id) do
    login_as_admin!(token)

    "help_forms"
    |> where([r], r.id == ^id)
    |> Repo.delete_all

    ok()
  end

  def delete_report(token, id) when is_binary(token) and is_integer(id) do
    login_as_admin!(token)

    "report_forms"
    |> where([r], r.id == ^id)
    |> Repo.delete_all

    ok()
  end

  def send_email(token, address, subject, reply)
    when is_binary(token) and is_binary(address) and
         is_binary(subject) and is_binary(reply) do
    login_as_admin!(token)

    send_plaintext_email(address, subject, reply)
    ok()
  end

end
