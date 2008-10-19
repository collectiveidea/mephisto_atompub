class Article < Content
  def self.from_atom(atom_body)
    atom_hash = XmlSimple.xml_in(atom_body, "ForceArray" => false)
    returning Article.new do |a|
      a.title = atom_hash["title"]["content"]
      a.body = atom_hash["content"]["content"]
      if atom_hash["control"]["draft"] == "no"
        a.published_at = Time.now
      end
    end
  end
end