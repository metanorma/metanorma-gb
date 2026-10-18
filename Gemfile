source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# Canonical dependency line: relaton 3.x prerelease monogem across the fleet.
gem "relaton", "= 3.0.0.pre.alpha.14"
gem "relaton-render", "= 3.0.0.pre.alpha.43"
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "pubid", github: "pubid/pubid", branch: "main"
gem "lutaml-model", "0.8.107"

# isodoc runs as a git gem here (SCSS on board), so the CSS pipeline needs the embedded compiler

gem "sassc-embedded", "~> 1.80"

# The TEMPORARY cross-PR pins (standoc#1232, document#45, iso
# model-validation-migration, core#18, mirror svgmap handlers) all merged.
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "isodoc", github: "metanorma/isodoc", branch: "main"

eval_gemfile("Gemfile.devel") rescue nil

gem "metanorma-mirror", github: "metanorma/metanorma-mirror", branch: "main"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
