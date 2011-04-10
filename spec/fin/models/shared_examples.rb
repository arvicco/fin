shared_examples_for 'model' do
 it 'has index method' do
   expect {subject.index }.to_not raise_error
 end
end
