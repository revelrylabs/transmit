defmodule Transmit.Signer do
  @moduledoc """
  Signer behaviour
  """

  @callback get_presigned_url(binary(), keyword()) ::
              {:error, binary()}
              | {:ok,
                 %{
                   file_url: binary(),
                   presigned_url: binary()
                 }}
end
