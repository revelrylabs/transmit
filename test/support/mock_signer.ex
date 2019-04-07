defmodule Transmit.MockSigner do
  @moduledoc false
  @behaviour Transmit.Signer

  def get_presigned_url("error" <> _, _) do
    {:error, "invalid file"}
  end

  def get_presigned_url(new_file_name, _) do
    {:ok,
     %{
       presigned_url: "https://presigned.com",
       file_url: "https://s3.amazonaws.com/test/uploads/#{new_file_name}"
     }}
  end
end
