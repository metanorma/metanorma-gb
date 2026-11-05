source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# Canonical dependency line: relaton 3.x prerelease monogem across the fleet.
gem "relaton", "~> 3.0"
gem "relaton-render", "~> 3.0"
gem "pubid", "~> 2.0"
gem "lutaml-model", "~> 0.8"
gem "leptris", "~> 1.9.384"
gem "moxml", "~> 0.5"

# isodoc runs as a git gem here (SCSS on board), so the CSS pipeline needs the embedded compiler

gem "sassc-embedded", "~> 1.80"

# The TEMPORARY cross-PR pins (standoc#1232, document#45, iso
# model-validation-migration, core#18, mirror svgmap handlers) all merged.
gem "metanorma-standoc", "~> 3.5.7"
gem "metanorma-document", "~> 0.5.3"
gem "isodoc", "~> 3.7.9"

eval_gemfile("Gemfile.devel") rescue nil

gem "metanorma-mirror", github: "metanorma/metanorma-mirror", branch: "main"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.7" # published flavor/taste table (metanorma-core#18)
