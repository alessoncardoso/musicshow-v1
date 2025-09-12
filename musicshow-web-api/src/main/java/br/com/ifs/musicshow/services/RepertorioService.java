package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.RepertorioDto;
import br.com.ifs.musicshow.models.BandaModel;
import br.com.ifs.musicshow.models.RepertorioModel;
import br.com.ifs.musicshow.repositories.BandaRepository;
import br.com.ifs.musicshow.repositories.RepertorioRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RepertorioService {

    private final RepertorioRepository repertorioRepository;
    private final BandaRepository bandaRepository;

    public List<RepertorioDto> listarRepertorios() {
        return repertorioRepository.findAll()
                .stream()
                .map(RepertorioDto::fromModel)
                .collect(Collectors.toList());
    }

    public List<RepertorioDto> listarRepertoriosBanda(Integer idBanda) {
        BandaModel banda = bandaRepository.getReferenceById(idBanda);
        return repertorioRepository.findByBanda(banda)
                .stream()
                .map(RepertorioDto::fromModel)
                .collect(Collectors.toList());
    }

    @Transactional
    public void cadastrarRepertorio(RepertorioDto repertorioDto) {
        BandaModel banda = bandaRepository.findById(repertorioDto.idBanda())
                .orElseThrow(() -> new EntityNotFoundException("Banda não encontrada."));

        RepertorioModel repertorioModel = new RepertorioModel();
        repertorioModel.setBanda(banda);
        repertorioModel.setNome(repertorioDto.nome());
        repertorioModel.setQtdMusica(repertorioDto.qtdMusica());
        repertorioModel.setDataCriacao(new Date());
        repertorioModel.setStatus(repertorioDto.status());

        repertorioRepository.save(repertorioModel);
        bandaRepository.incrementarQtdRepertorios(repertorioDto.idBanda());
    }

    @Transactional
    public void atualizarRepertorio(Integer id, RepertorioDto repertorioDto) {
        RepertorioModel repertorioAtual = repertorioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Repertório não encontrado."));

        repertorioAtual.setNome(repertorioDto.nome());
        repertorioAtual.setQtdMusica(repertorioDto.qtdMusica());
        repertorioAtual.setStatus(repertorioDto.status());

        repertorioRepository.save(repertorioAtual);
        RepertorioDto.fromModel(repertorioAtual);
    }

    @Transactional
    public void deletarRepertorio(RepertorioDto repertorioDto) {
        if (!repertorioRepository.existsById(repertorioDto.id())) {
            throw new RuntimeException("Repertório não encontrado.");
        }

        repertorioRepository.deleteById(repertorioDto.id());
        bandaRepository.decrementarQtdRepertorios(repertorioDto.idBanda());
    }

}
