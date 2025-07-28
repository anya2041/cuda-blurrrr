#include <opencv2/opencv.hpp>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <filesystem>  // C++17

namespace fs = std::filesystem;

double compute_blur(const cv::Mat& img) {
    cv::Mat gray, lap;
    cv::cvtColor(img, gray, cv::COLOR_BGR2GRAY);
    cv::Laplacian(gray, lap, CV_64F);
    cv::Scalar mean, stddev;
    cv::meanStdDev(lap, mean, stddev);
    return stddev.val[0] * stddev.val[0];
}

int main() {
    std::string folder_path = "images";
    std::string csv_filename = "blur_results.csv";
    std::ofstream csv_file(csv_filename);
    if (!csv_file.is_open()) {
        std::cerr << "Failed to open CSV file for writing.\n";
        return -1;
    }

    csv_file << "Filename,BlurScore,Blurry\n";

    for (const auto& entry : fs::directory_iterator(folder_path)) {
        if (!entry.is_regular_file()) continue;

        std::string file_path = entry.path().string();
        std::string file_name = entry.path().filename().string();

        cv::Mat img = cv::imread(file_path);
        if (img.empty()) {
            std::cerr << "Failed to load: " << file_path << "\n";
            continue;
        }

        double score = compute_blur(img);
        bool is_blurry = score < 100.0;

        std::cout << file_name << ": Score = " << score
                  << " => " << (is_blurry ? "Blurry" : "Not Blurry") << "\n";

        csv_file << file_name << "," << score << "," << (is_blurry ? "Yes" : "No") << "\n";
    }

    csv_file.close();
    std::cout << "Results saved to: " << csv_filename << "\n";

    return 0;
}
