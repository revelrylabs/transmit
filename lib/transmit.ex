defmodule Transmit do
  @moduledoc """
  Plug for handling the creation of presigned urls for direct client-side uploading

  ## Setup

  In your router, add the following:

  ```elixir
  defmodule MyAppWeb.Router do
    use MyAppWeb, :router

    ...

    forward("/signer", Transmit, signer: Transmit.S3Signer, bucket: "images", path: "uploads")

    ...
  ```

  This makes it so that requests to `/signer` will be routed to the Transmit plug.
  The `signer` that will be used is the `Transmit.S3Signer` for creating S3 presigned URLs.
  The `bucket` and `path` options are specific to `Transmit.S3Signer` which will use them to
  create URLs that point to the `images` bucket under the path `uploads`

  For more setup information for S3 signing, make sure to check the `Transmit.S3Signer` documentation


  Different signers can be used by implementing the `Transmit.Signer` behaviour

  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn
    |> fetch_query_params()
    |> handle(opts)
  end

  defp handle(%Plug.Conn{query_params: %{"file_name" => file_name}} = conn, opts) do
    signer = Keyword.get(opts, :signer, Transmit.S3Signer)

    uri = URI.parse(file_name)
    uuid = UUID.uuid4()

    extension =
      uri.path
      |> Path.extname()
      |> String.downcase()

    basename =
      uri.path
      |> Path.basename(extension)
      |> String.downcase()

    new_file_name = "#{basename}-#{uuid}#{extension}"
    result = signer.get_presigned_url(new_file_name, opts)

    case result do
      {:ok, %{presigned_url: signed_url, file_url: url}} ->
        response = %{
          data: %{
            signed_request: signed_url,
            file_name: new_file_name,
            file_type: MIME.type(String.replace_leading(extension, ".", "")),
            url: url
          }
        }

        json(conn, opts, 200, response)

      {:error, _} ->
        json(conn, opts, 422, %{
          errors: [
            %{
              title: "S3 Error",
              detail: "Unable to create presigned url."
            }
          ]
        })
    end
  end

  defp handle(conn, opts) do
    json(conn, opts, 422, %{
      errors: [
        %{
          title: "Missing query parameter",
          detail: "The request does not contain a 'file_name' query parameter"
        }
      ]
    })
  end

  defp json(conn, opts, status, map) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      status,
      json_library(opts).encode!(map)
    )
  end

  defp json_library(opts) do
    Keyword.get(opts, :json_library, Jason)
  end
end
