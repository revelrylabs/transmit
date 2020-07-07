defmodule Transmit.S3Signer do
  @moduledoc """
  Transmit.Signer for AWS S3 Presigned URLs

  Make sure to install ex_aws and ex_aws_s3 as dependencies in your project:

  ```elixir
  def deps do
  [
    {:ex_aws, "~> 2.0"},
    {:ex_aws_s3, "~> 2.0"},
  ]
  end
  ```

  Also make sure to follow setup instructions: [https://github.com/ex-aws/ex_aws#aws-key-configuration](https://github.com/ex-aws/ex_aws#aws-key-configuration)

  ## Options
  accepts the following options:
    * `:bucket` - The S3 bucket to use
    * `:path` - the path in the bucket. (defaults to `uploads`)

  """
  @behaviour Transmit.Signer

  def get_presigned_url(new_file_name, opts) do
    bucket = Keyword.fetch!(opts, :bucket)
    path = Keyword.get(opts, :path, "uploads")

    case ExAws.S3.presigned_url(
           ExAws.Config.new(:s3),
           :put,
           bucket,
           Path.join(path, new_file_name)
         ) do
      {:ok, presigned_url} ->
        {:ok,
         %{
           presigned_url: presigned_url,
           file_url: "https://#{bucket}.s3.amazonaws.com/#{path}/#{new_file_name}"
         }}

      {:error, _} = error ->
        error
    end
  end
end
