class Localmaxmatching < Formula
  desc "Efficient parallel and sequential algorithms for graph matching"
  homepage "https://github.com/LocalMaxMatching/LocalMaxMatching"
  url "https://github.com/LocalMaxMatching/LocalMaxMatching/archive/refs/tags/v1.0.tar.gz"
  sha256 "12008952ea350e942544c640b4656c075aacfeb8a8500cac467d3f91e4cd4220"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "open-mpi" => :recommended

  def install
    args = std_cmake_args + ["-DCMAKE_BUILD_TYPE=Release"]

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
