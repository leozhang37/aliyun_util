defmodule Aliyun.Util.Encoder do
  @doc """
    编码字符串：URL编码+POP特殊规则
  """
  @spec encode_string(String.t()) :: String.t()
  def encode_string(term) do
    term
    |> to_string()
    |> URI.encode_www_form()
    |> String.replace("+", "%20")
  end

  @doc """
    编码 requet: verb(GET|POST) + query_params
  """
  @spec encode_request(String.t(), map()) :: <<_::16, _::_*8>>
  def encode_request(verb, params) do
    verb <> "&" <> encode_string("/") <> "&" <> encode_params(params)
  end

  @doc """
    编码 query params
  """
  @spec encode_params(map()) :: String.t()
  def encode_params(params) do
    params
    |> Map.delete("Signature")
    |> Enum.sort()
    |> Stream.map(fn {k, v} ->
      encode_string(k) <> "=" <> encode_string(v)
    end)
    |> Enum.join("&")
    |> encode_string()
  end
end
