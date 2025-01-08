import json
import argparse

def find_all_awslambdas(data, results=None):
    if results is None:
        results = []
        
    if isinstance(data, dict):
        for key, value in data.items():
            if key == "awslambdas":
                results.append(value)
            else:
                find_all_awslambdas(value, results)
    elif isinstance(data, list):
        for item in data:
            find_all_awslambdas(item, results)
    
    return results

def main(json_file_path):
    try:
        with open(json_file_path, 'r') as file:
            data = json.load(file)
        
        all_awslambdas = find_all_awslambdas(data)
        
        if not all_awslambdas:
            print("No 'lambdas' key found in the JSON file.")
            return
        
        for idx, awslambdas in enumerate(all_awslambdas, start=1):
            print(f"\nLambda Function # {idx}:")
            
            if isinstance(awslambdas, dict):
                for lambda_name, details in awslambdas.items():
                    print(f"\nLambda Function Name: {lambda_name}")
                    
                    env_vars = details.get("env_variables")
                    if env_vars:
                        print("Environment Variables:")
                        print(json.dumps(env_vars, indent=2))
                    else:
                        print("No Environment Variables found for this lambda.")
            else:
                print("'awslambdas' is not in the expected dictionary format.")
                
    except FileNotFoundError:
        print(f"File not found: {json_file_path}")
    except json.JSONDecodeError:
        print("Invalid JSON format.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parse a JSON file to find all occurrences of 'awslambdas' entries and associated 'env_variables'.")
    parser.add_argument("json_file_path", type=str, help="Path to the JSON file")
    args = parser.parse_args()

    main(args.json_file_path)
