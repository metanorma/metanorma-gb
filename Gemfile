source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# Canonical dependency line: relaton 3.x prerelease monogem across the fleet.
gem "relaton", "~> 3.0"
gem "relaton-render", "~> 3.0"
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "pubid", "~> 2.0"
gem "lutaml-model", "~> 0.8"
gem "leptris", "~> 1.9.384"
gem "moxml", "~> 0.5"

# isodoc runs as a git gem here (SCSS on board), so the CSS pipeline needs the embedded compiler

gem "sassc-embedded", "~> 1.80"

# The TEMPORARY cross-PR pins (standoc#1232, document#45, iso
# model-validation-migration, core#18, mirror svgmap handlers) all merged.
gem "metanorma-standoc", "~> 3.5.1.pre.alpha"
gem "metanorma-document", "~> 0.5.2.pre.alpha"
gem "isodoc", "~> 3.7.4.pre.alpha"

eval_gemfile("Gemfile.devel") rescue nil

gem "metanorma-mirror", github: "metanorma/metanorma-mirror", branch: "main"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
