class Site

  def self.enabled
    $sites.select { |site| $sites[site][:enabled] }.map { |site| site[1]}
  end

end