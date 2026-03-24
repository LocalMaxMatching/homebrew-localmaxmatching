class Localmaxmatching < Formula
  desc "Efficient parallel and sequential algorithms for graph matching"
  homepage "https://github.com/LocalMaxMatching/LocalMaxMatching"
  url "https://github.com/LocalMaxMatching/LocalMaxMatching/archive/refs/tags/v1.0.tar.gz"
  sha256 "7c20da2457947b625640c396ca84e4d0426521a332d1b1f2779322e951ef4f92"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "open-mpi"

  on_linux do
    depends_on "gcc"
  end

  def install
    args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Release"]

    if OS.linux?
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version.major}"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version.major}"
      args += [
        "-DCMAKE_C_COMPILER=#{ENV["CC"]}",
        "-DCMAKE_CXX_COMPILER=#{ENV["CXX"]}",
      ]
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", ".", "--parallel", ENV.make_jobs.to_s
    end

    bin.install Dir["deploy/*"]
  end

  test do
    system bin/"local_max_matching", "--kn", "--vertices", "10", "--edge_rating", "const"
  end
end
